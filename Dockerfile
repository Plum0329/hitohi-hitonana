FROM ruby:3.2.2

# 必要なパッケージのインストール
RUN apt-get update -qq && \
    apt-get install -y build-essential \
                       libpq-dev \
                       nodejs \
                       postgresql-client \
                       git \
                       curl && \
    curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y nodejs \
                       yarn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 作業ディレクトリの作成
WORKDIR /app

# GemfileとGemfile.lockをコピー
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

# Bundlerの実行
RUN gem install bundler:2.4.22 && \
    bundle config set --local without 'production' && \
    bundle install

# アプリケーションのソースをコピー
COPY . /app/

# Railsサーバーの起動ポート
EXPOSE 3000

# コンテナ起動時のコマンド
CMD ["rails", "server", "-b", "0.0.0.0"]