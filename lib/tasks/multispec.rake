# frozen_string_literal: true
desc "Runs tests with a variety of backends"
task :multispec do
  # TODO: fix fedora/fedora
  profiles = [
    { metadata: 'memory',   storage: 'memory' },
    { metadata: 'postgres', storage: 'disk' }
  ]
  profiles.each do |profile|
    ENV['VALKYRIE_METADATA'] = profile[:metadata]
    ENV['VALKYRIE_STORAGE'] = profile[:storage]
    puts "\n\nProfile: metadata_adapter=#{profile[:metadata]}, storage_adapter=#{profile[:storage]}\n\n"
    Rake::Task['spec'].execute
  end
end
