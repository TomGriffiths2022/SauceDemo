# TODO:

Overview of your test-pack required with instructions on everything required to run your tests

---

## Dependencies

- [ ] Ruby (>= 3.4)
- [ ] Chromedriver (latest)

---

## Running your tests

### Local driver

1. Firstly `bundle install` the required gems
2. Ensure you have a driver available for your tests to use: `which chromedriver`
   1. If not available, install using `brew`: `brew install --cask chromedriver`
3. Use `browser_config.driver` to change your desired driver in `config/settings.yml`. Alternatively export `DRIVER=xxx` as an environment variable
4. `bundle exec cucumber`
