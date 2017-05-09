# frozen_string_literal: true
require 'rails_helper'

RSpec.describe BooksController do
  describe "GET /books/new" do
    it "renders a form with a new book" do
      get :new

      expect(response).to be_success
    end
  end

  describe "POST /books" do
    let(:file) { fixture_file_upload('files/example.tif', 'image/tiff') }
    it "can upload a file" do
      post :create, params: { book: { title: ["Test"], files: [file] } }

      id = response.location.gsub("http://test.host/catalog/", "").gsub("%2F", "/").gsub(/^id-/, "")
      query_service = Valkyrie.config.adapter.query_service
      book = query_service.find_by(id: Valkyrie::ID.new(id))
      expect(book.member_ids).not_to be_blank
      file_set = query_service.find_members(model: book).first
      file = query_service.find_members(model: file_set).first

      expect(file.file_identifiers).not_to be_empty
      expect(file.label).to contain_exactly "example.tif"
    end
  end

  describe "GET /books/:id/append/book" do
    it "renders a form to append a child book" do
      parent = Persister.save(model: Book.new)
      get :append, params: { id: parent.id, model: Book }

      expect(assigns(:form).append_id).to eq parent.id
    end
  end

  describe "PUT /books" do
    it "can set member IDs" do
      resource = Persister.save(model: Book.new(title: "Test"))
      child = Persister.save(model: Book.new)
      put :update, params: { book: { member_ids: [child.id.to_s] }, id: resource.id }

      expect(response).to be_redirect
      reloaded = QueryService.find_by(id: resource.id)
      expect(QueryService.find_members(model: reloaded)).not_to be_blank
    end
  end

  describe "GET /books/:id/append/page" do
    it "renders a form to append a child page" do
      parent = Persister.save(model: Page.new)
      get :append, params: { id: parent.id, model: Page }

      expect(assigns(:form).class).to eq PageForm
      expect(assigns(:form).append_id).to eq parent.id
    end
  end

  describe "GET /books/:id/file_manager" do
    it "sets the record and children variables" do
      child = Persister.save(model: Book.new)
      parent = Persister.save(model: Book.new(member_ids: child.id))

      get :file_manager, params: { id: parent.id }

      expect(assigns(:record).id).to eq parent.id
      expect(assigns(:children).map(&:id)).to eq [child.id]
    end
  end
end
