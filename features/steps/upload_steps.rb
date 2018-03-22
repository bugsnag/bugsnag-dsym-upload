When("I upload dSYMS with options {string}") do |args|
  set_script_env('UPLOAD_ARGS', args)
  step('I run the script "features/scripts/upload-with-args.sh" synchronously')
end
