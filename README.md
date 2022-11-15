  * https://www.ifj.edu.pl/dept/no6/nz62/www/
  * github pages https://grzanka.github.io/nz62www/

Clone the repo:

```bash
git clone git@github.com:grzanka/nz62www.git --recursive
```

or
```bash
git clone git@github.com:grzanka/nz62www.git
git submodule update --init
```

Install Hugo:

```bash
sudo snap install hugo
```

or:

```bash
cd nz62www
python3 -m venv venv
source venv/bin/activate
pip install hugo
```

Generate the website:

```
hugo
```
