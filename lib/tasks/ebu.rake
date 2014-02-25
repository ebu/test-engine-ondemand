namespace :ebu do
  namespace :jobs do
    desc "Transition all eligible encoding jobs"
    task :transition => :environment do
      EncodingJob.transition
    end
  end
end

