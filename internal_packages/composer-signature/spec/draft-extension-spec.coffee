{Message} = require 'nylas-exports'

SignatureDraftStoreExtension = require '../lib/signature-draft-extension'

describe "SignatureDraftStoreExtension", ->
  describe "prepareNewDraft", ->
    describe "when a signature is defined", ->
      beforeEach ->
        @signature = "<div id='signature'>This is my signature.</div>"
        spyOn(NylasEnv.config, 'get').andCallFake =>
          @signature

      it "should insert the signature at the end of the message or before the first blockquote and have a newline", ->
        a = new Message
          draft: true
          body: 'This is a test! <blockquote>Hello world</blockquote>'
        b = new Message
          draft: true
          body: 'This is a another test.'

        SignatureDraftStoreExtension.prepareNewDraft(a)
        expect(a.body).toEqual("This is a test!<br/><div id='signature'>This is my signature.</div><blockquote>Hello world</blockquote>")
        SignatureDraftStoreExtension.prepareNewDraft(b)
        expect(b.body).toEqual("This is a another test<br/><div id='signature'>This is my signature.</div>")

    describe "when a signature is not defined", ->
      beforeEach ->
        spyOn(NylasEnv.config, 'get').andCallFake ->
          null

      it "should not do anything", ->
        a = new Message
          draft: true
          body: 'This is a test! <blockquote>Hello world</blockquote>'
        SignatureDraftStoreExtension.prepareNewDraft(a)
        expect(a.body).toEqual('This is a test! <blockquote>Hello world</blockquote>')
