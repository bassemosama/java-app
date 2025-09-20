node{
    git branch: 'main', url: 'https://github.com/bassemosama/node-app.git'
    stage('Build') {
        try{
            sh'echo "Building"'
        }
        catch(Exception e){
            sh'echo "Build Failed"'
            throw e
        }
    }
    stage('Test') {
       if (env.BRANCH_NAME == 'fear'){
           
               sh'echo "Testing"'
       }
       else{
           sh'echo "Skipping Tests"'
       }
    }


}