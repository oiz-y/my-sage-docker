# How to Use

```
docker build -t my_sage .
docker run -v $(pwd)/src:/src -e num=31 -e time=0001 -e table_name=my_table my_sage
```

```
docker build -t my_sage .
docker run -v $(pwd)/src:/src -e polynomial="x^3 + x^2 + 1" -e time=0002 -e table_name=my_table -e conj_table=conjugacy_rate_table my_sage
```
