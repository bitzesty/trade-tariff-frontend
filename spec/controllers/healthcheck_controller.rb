require 'spec_helper'

describe HealthCheckController do
  it "returns success on request" do
    get :check
    response.status.should == 200
  end

  it "throws a 500 on no API connection" do
    Section.stubs(:all).raises(ApiEntity::Error.new("502 Bad Gateway"))
    get :check
    response.status.should == 500
  end
end
