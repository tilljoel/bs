#!/bin/zsh
export RUBY=`rbenv which ruby`
export CUCUMBER=`rbenv which cucumber`

# Run each test file individually

for file in test/**/test_*.rb
do
  if test -f "$file"
  then
    echo "Run tests in: #${file}"
    $RUBY -Itest $file;
  fi
done

# Run each feature file individually

echo $CUCUMBER
for file in features/**/*.feature
do
  if test -f "$file"
  then
    echo "Run features in: #${file}"
    /opt/boxen/rbenv/shims/bundle exec $CUCUMBER $file
  fi
done
