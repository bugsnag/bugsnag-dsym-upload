When("I upload dSYMS with options {string}") do |args|
  set_script_env('UPLOAD_ARGS', args)
  step('I run the script "features/scripts/upload-with-args.sh" synchronously')
end

# A scenario where a user wraps the dSYM path in quotes to escape whitespace in the path
When("I upload dSYMS with options {string} and dSYM path {string}") do |args, dsyms_path|
  set_script_env('UPLOAD_ARGS', args)
  set_script_env('DSYMS_PATH', dsyms_path)
  step('I run the script "features/scripts/upload-with-dsym-path.sh" synchronously')
end
