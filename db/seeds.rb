# 俳句と川柳のタグを作成
Tag.find_or_create_by!(name: '俳句')
Tag.find_or_create_by!(name: '川柳')

# 字数チェック用のタグを作成
Tag.find_or_create_by!(name: '字足らず')
Tag.find_or_create_by!(name: '字余り')