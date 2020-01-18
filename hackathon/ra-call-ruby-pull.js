//JavaScript code to spawn a shell and run the Ruby script.
//Version 1.0 - Randy "RJ" Clark

const { exec } = require('child_process');
exec('ruby ra-pull-data.rb', (err, stdout, stderr) => {
  if (err) {
    // node couldn't execute the command
    return;
  }

  // the *entire* stdout and stderr (buffered)
  console.log(`stdout: ${stdout}`);
  console.log(`stderr: ${stderr}`);
});