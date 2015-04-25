# encoding: utf-8
# 对帐
# rake check
task :check do
  unless Rails.env == 'production' # 防止生产环境下执行
    refunds = 0
    prices  = 0

    File.readlines('alipay.txt')[5..-5].each do |line|
      info = line.split(',')
      number = info[1]
      price  = info[9].to_f
      fee    = info[12]
      refund = info[13].to_f

      prices  += price
      refunds += refund
      puts number if refund > 0
      # puts number if refund > 0 && price != refund
      # puts "#{number}, #{price}, #{fee}, #{refund}"
    end

    puts prices
    puts refunds
  end
end
