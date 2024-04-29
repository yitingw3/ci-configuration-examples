pipeline {
    agent none
    stages {
        // stage('Compile and test MEX on matrix agents') {
        //     matrix {
        //         axes {
        //             axis {
        //                 name 'OS'
        //                 values 'mac_jianwei'
        //             }
        //         }
        //         stages {
        //             stage("Compile and test MEX") {
        //                 agent { label "${OS}" } // Assumes you have labels corresponding to the OS types
        //                 steps {
        //                     script {
        //                         matlabver = tool '2024a_mac_jianwei'
        //                         if (isUnix()) {
        //                             env.PATH = "${matlabver}/bin:${env.PATH}"   // Linux or macOS agent
        //                         } else {
        //                             env.PATH = "${matlabver}\\bin;${env.PATH}"   // Windows agent
        //                         }
        //                         runMATLABBuild(tasks: 'mex test')
        //                         junit testResults: 'test-results/results.xml', skipPublishingChecks: true
        //                         stash includes: 'toolbox/*.mex*', name: "mex-${OS}"
        //                     }
        //                 }
        //             }
                    
        //         }
        //     }
        // }
        stage('Create and release toolbox') {
            agent { label 'linux' }
            environment {
                GITHUB_TOKEN = credentials('github-token') // Store your GitHub token as a Jenkins credential
            }
            tools {
                matlab '2024a_mac_jianwei'
            }
            steps {
                script {
                    // Loop through agents to unstash files
                    def agents = ['mac_jianwei']
                    agents.each { OS ->
                        unstash "mex-${OS}"
                    }
                }
                runMATLABBuild(tasks: 'packageToolbox')
                script {
                    // Create release
                    def name = "Cross-Platform Array Product Toolbox"
                    def repoOwner = "yitingw3"
                    def repoName = "ci-configuration-examples"
                    def createReleaseCmd = """curl -XPOST -H "Authorization: Bearer ${GITHUB_TOKEN}" --data "{\\"tag_name\\": \\"v1.${env.BUILD_NUMBER}.3\\", \\"name\\": \\"${name}\\"}" https://api.github.com/repos/${repoOwner}/${repoName}/releases"""
                    def release = sh(script: createReleaseCmd, returnStdout: true).trim()
                    def id = release.tokenize(',')[0].replaceAll(/[^0-9]/, '')

                    // Upload the artifact
                    def artifactPath = "toolbox.mltbx"
                    sh """curl -XPOST -H "Authorization:token ${GITHUB_TOKEN}" -H "Content-Type:application/octet-stream" --data-binary @${artifactPath} https://uploads.github.com/repos/${repoOwner}/${repoName}/releases/${id}/assets?name=toolbox.mltbx"""
                }
            }
        }
    } 
}
