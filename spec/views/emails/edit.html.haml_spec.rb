require 'spec_helper'

describe "emails/edit.html.haml" do
  before(:each) do
    @email = assign(:email, stub_model(Email,
      :new_record? => false
    ))
  end

  it "renders the edit email form" do
    render

    rendered.should have_selector("form", :action => email_path(@email), :method => "post") do |form|
    end
  end
end
