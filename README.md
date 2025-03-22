
# Shark Website 🐬

Welcome to Shark Website, a sleek and dynamic web application 🌊
# My Project Structure 📁

shark-website/  
├── README.md                                       
├── app.js                  
├── views/                
│   ├── css/                
│   │   ├── styles.css    
│   ├── index.html        
│   ├── sharks.html        
├── Dockerfile            
├── appspec.yml           
├── buildspec.yml           
├── package.json          
├── package-lock.json     
├── terraform/            
│   ├── backend/            
│   ├── deployment/        
│   ├── infra/           
├── scripts/              
│   ├── pull_image.sh    
│   ├── start_service.sh

## Tech Stack 💻
### Aplication ☀️
**HTML** : Structures the website’s content with clean, semantic markup.

**CSS** : Styles the interface for a modern, responsive design.

**JavaScript** : Powers interactivity and dynamic features on the front end.
### Cloud computing AWS ☁️

**EC2** : Runs the website on a virtual server.

**S3** : Store artifacts and contents on bucket.

**ECR** : Holds the Docker images for deployment.

**IAM Role** : Manages permissions for AWS services.

### CI/CD Pipeline 🎏

**CodeBuild**: Builds the app and prepares it for deployment.

**CodeDeploy**: Puts the app on the server.

**CodePipeline**: Automates the whole process from code to live site.

### Infrastructure 🏣
**Terraform**: Sets up and manages AWS resources easily with code.

- Defines the EC2 instance, S3 bucket, and ECR repository.

- Configures IAM roles and policies for secure access.

- Enables quick updates or scaling with reusable scripts.
### Containerization 🚢
**Docker**: Packages the app for smooth and consistent running.

## Authors

- [@bulma1](https://www.github.com/bulma1)

