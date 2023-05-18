=begin

- API defined in app/controllers/api/project_controller.rb
  - Related routes defined in config/routes.rb

=end

require 'rails_helper'

describe 'Projects API', type: :request do
  it 'loads a project' do
    user = FactoryBot.create(:user)
    FactoryBot.create(:project, name: "Sample Project")
    FactoryBot.create(:project, name: "Second Sample Project", owner: user)
    FactoryBot.create(:project, name: "Third Sample Project", owner: user)

    # GET /api/projects (api/projects#index)
    get api_projects_path, params: {
      user_email: user.email,
      user_token: user.authentication_token
    }

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json.length).to eq 2
    project_id = json[0]["id"]

    # GET /api/projects/id (api/projects#show)
    get api_project_path(project_id), params: {
      user_email: user.email,
      user_token: user.authentication_token
    }

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json["name"]).to eq "Second Sample Project"
    # Etc.
  end

  it 'creates a project' do
    user = FactoryBot.create(:user)
    FactoryBot.create(:project, name: "Sample Project")
    FactoryBot.create(:project, name: "Second Sample Project", owner: user)

    project_attributes = FactoryBot.attributes_for(:project)

    expect {
      # POST /api/projects (api/projects#create)
      post api_projects_path, params: {
        user_email: user.email,
        user_token: user.authentication_token,
        project: project_attributes
      }
    }.to change(user.projects, :count).by(1)

    expect(response).to have_http_status(:success)
  end

  it 'updates a project' do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, name: "Sample Project", owner: user)
    project_attributes = FactoryBot.attributes_for(:project, name: "Altered Naming")

    # PATCH /api/projects/id (api/projects#update)
    patch api_project_path(project.id), params: {
      user_email: user.email,
      user_token: user.authentication_token,
      project: project_attributes
    }

    json = JSON.parse(response.body)
    expect(json["name"]).to eq("Altered Naming")
  end


  it 'deletes a project' do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, name: "Sample Project", owner: user)

    # DELETE /api/projects/id (api/projects#destroy)
    delete api_project_path(project.id), params: {
      user_email: user.email,
      user_token: user.authentication_token
    }
    json = JSON.parse(response.body)
    expect(json["status"]).to eq("destroy")
  end
end
