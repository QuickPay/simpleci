# -*- encoding: utf-8; mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
$LOAD_PATH.push(File.realdirpath(File.dirname(__FILE__)))

task :environment do
  require "./config/environment"
end

FileList["lib/tasks/*.rake"].each do |task|
  import task
end
