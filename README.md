# How to Use

```
docker build -t my_sage .
docker run -v $(pwd)/src:/src -e num=31 my_sage
```



# Directory Structure

```
.
|--- Dockerfile
|--- src
      |--- run.sh
      |--- create_json.py
      |--- sample.sage
```
