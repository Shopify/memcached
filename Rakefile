# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "rake/extensiontask"

Rake::ExtensionTask.new("rlibmemcached") do |ext|
  ext.ext_dir = 'ext/memcached'
  ext.lib_dir = "lib/memcached"
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task default: %i(compile test)

ENV["GEM_CERTIFICATE_CHAIN"]="memcached.pem"

Rake::Task[:clean].enhance do
  FileUtils.rm_rf(File.read(".gitignore").lines.flat_map { |l| Dir["**/#{l.chomp}"] })
end

task :swig do
  run("swig -DLIBMEMCACHED_WITH_SASL_SUPPORT -Iext/libmemcached-0.32 -ruby -autorename -o ext/rlibmemcached_wrap.c.in ext/rlibmemcached.i", "Running SWIG")
  swig_patches = {
    "#ifndef RUBY_INIT_STACK" => "#ifdef __NEVER__" # Patching SWIG output for JRuby.
  }.map{|pair| "s/#{pair.join('/')}/"}.join(';')
  # sed has different syntax for inplace switch in BSD and GNU version, so using intermediate file
  run("sed '#{swig_patches}' ext/rlibmemcached_wrap.c.in > ext/rlibmemcached_wrap.c", "Apply patches to SWIG output")
end

task :exceptions do
  $LOAD_PATH << "lib"
  require 'memcached'
  Memcached.constants.sort.each do |const_name|
    const = Memcached.send(:const_get, const_name)
    next if const == Memcached::Success or const == Memcached::Stored
    if const.is_a? Class and const < Memcached::Error
      puts "* Memcached::#{const_name}"
    end
  end
end

task :benchmark do
 exec("ruby #{File.dirname(__FILE__)}/test/profile/benchmark.rb")
end

task :rb_profile do
 exec("ruby #{File.dirname(__FILE__)}/test/profile/rb_profiler.rb")
end

task :c_profile do
 exec("ruby #{File.dirname(__FILE__)}/test/profile/c_profiler.rb")
end

task :valgrind do
 exec("ruby #{File.dirname(__FILE__)}/test/profile/valgrind.rb")
end

def with_vm(vm, cmd)
  bindir = vm.split("/")[0..-2].join("/")
  puts "#{vm} #{cmd} started"
  if !File.exist?("#{bindir}/rake")
    puts "#{vm} not found"
    exit(1)
  elsif system("bash --norc --noprofile -c 'export PATH=#{bindir}:/bin:/usr/bin && which rake && #{bindir}/rake clean && #{bindir}/rake compile'")
    puts "#{vm} compiled"
    if system("bash --norc --noprofile -c 'export PATH=#{bindir}:/bin:/usr/bin && #{bindir}/rake #{cmd}'")
      puts "#{vm} #{cmd} success (1st try)"
    elsif system("bash --norc --noprofile -c 'export PATH=#{bindir}:/bin:/usr/bin && #{bindir}/rake #{cmd}'")
      puts "#{vm} #{cmd} success (2nd try)"
    else
      puts "#{vm} #{cmd} failed"
      exit(1)
    end
  else
    puts "#{vm} compilation failed"
    exit(1)
  end
end

task :test_20 do
  with_vm("/usr/bin/ruby", "test")
end

task :test_19 do
  with_vm("/opt/local/bin/ruby1.9", "test")
end

task :test_rbx do
  with_vm("/usr/local/rubinius/1.2.4/bin/rbx", "test")
end

task :test_all => [:test_20, :test_19, :test_rbx]

task :prerelease => [:manifest, :test_all, :install]

task :benchmark_all do
  with_vms("benchmark CLIENT=libm")
end

def run(cmd, reason)
  puts reason
  puts cmd
  raise "'#{cmd}' failed" unless system(cmd)
end
