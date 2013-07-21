shared_context "delay jobs", :delay => true do
  before {
    Delayed::Job.delete_all
    Delayed::Worker.stub(:delay_jobs => true)
  }
end
