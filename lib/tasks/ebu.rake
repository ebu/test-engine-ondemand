namespace :ebu do
  namespace :jobs do
    desc "Transition all eligible encoding jobs"
    task :transition => :environment do
      EncodingJob.transition
    end
  end
  
  namespace :organizations do
    desc "Load temp organizations in DB"
    task :load => :environment do
      Organization.create(name: 'BBC',           ebu_id: 16)
      Organization.create(name: 'Clear Channel', ebu_id: 7)
      Organization.create(name: 'EBU',           ebu_id: 3,  can_write: true)
      Organization.create(name: 'MR',            ebu_id: 15)
      Organization.create(name: 'NL',            ebu_id: 8)
      Organization.create(name: 'NOVA',          ebu_id: 13)
      Organization.create(name: 'OUI FM',        ebu_id: 12)
      Organization.create(name: 'Radio FG',      ebu_id: 14)
      Organization.create(name: 'Radio France',  ebu_id: 6)
      Organization.create(name: 'RMC',           ebu_id: 10)
      Organization.create(name: 'RTBF',          ebu_id: 11)
      Organization.create(name: 'RTS',           ebu_id: 5)
      Organization.create(name: 'RTVSLO',        ebu_id: 4)
      Organization.create(name: 'SR',            ebu_id: 9)
      Organization.create(name: 'SVT',           ebu_id: 17)
    end
  end
  
  desc "Purge expired file assets and encoding jobs"
  task :purge => :environment do
    EncodingJob.purge!
    FileAsset.purge!
  end
end

