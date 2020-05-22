# frozen_string_literal: true

# Получаем абсолютный путь к файлу
def get_filepath(filepath)
  filename = File.join(File.expand_path(Dir.pwd), filepath)
  unless File.file?(filename)
    puts "file #{filename} not finded"
    raise Errno::ENOENT
  end
  filename
end

# Скриншот в конце каждого сценария, в папку report_files
def screenshot
  time = Time.now.strftime('%Y-%m-%d_%H-%M-%S')
  filename = 'report_files/' + "error- #{time}.png"
  @browser.save_screenshot(filename)
  embed(filename, 'image/png')
end

# Выключаем браузер
def quit_browser
  @browser.quit
end

# Таймауты
def set_page_timeouts
  @browser.manage.timeouts.implicit_wait = 10 # 10
  @browser.manage.timeouts.script_timeout = 30 # 10
  @browser.manage.timeouts.page_load = 30
end