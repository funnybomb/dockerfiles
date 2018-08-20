## docker file to build jupyter docker
```
docker build -f Dockerfile.x -t xxx ./
```

1.Dockerfile.basebook : basic dockerfile for jupyter
2.dockerfile.R : based on basebook
3.dockerfile.cytoflow: based on basebook to install cytoflow to read *.fcs files
4.dockerfile.hdbscan: based on cytoflow to install hdbscan to cluster data using hdbscan
5. 
