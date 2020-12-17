# frozen_string_literal: true

require("#{File.dirname(__FILE__)}/../setup")

def valgrind(args)
  exec(
    'valgrind',
    *args,
    '--dsymutil=yes', 'ruby', "-r#{File.dirname(__FILE__)}/exercise.rb",
    '-e', "Worker.new(ENV['TEST'] || 'everything', (ENV['LOOPS'] || 50).to_i, 'true').work"
  )
end

case ENV["TOOL"]
when nil, "memcheck"
  valgrind(%w(
    --tool=memcheck --error-limit=no --undef-value-errors=no --leak-check=full --show-reachable=no --num-callers=15
    --track-fds=yes --workaround-gcc296-bugs=yes --leak-resolution=med --max-stackframe=7304328
  ))
when "massif"
  valgrind(%w(--tool=massif --time-unit=B))
end
