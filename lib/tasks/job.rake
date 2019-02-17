namespace :job do
  desc "登録されているrssを取得します。"
  task fetch_rss: :environment do
    FetchRssJob.perform_now
  end
end
