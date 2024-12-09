# 必要なパッケージのロード
library(dplyr)
# トレーニングデータの読み込み
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
# テストデータの読み込み
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
# 特徴量名の読み込み
features <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
# データの結合
X_data <- rbind(X_train, X_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)
# 2. mean()とstd()を含む特徴量の抽出
mean_std_features <- grep("mean\\(\\)|std\\(\\)", features[, 2])
X_data <- X_data[, mean_std_features]
# 3. 活動ラベルの記述的な名前への変更
y_data[, 1] <- activities[y_data[, 1], 2]
# 4. 変数名のラベル付け
names(X_data) <- features[mean_std_features, 2]
names(y_data) <- "Activity"
names(subject_data) <- "Subject"
# すべてのデータを結合
all_data <- cbind(subject_data, y_data, X_data)
# 5. 平均値を含む新しいデータセットの作成
tidy_data <- all_data %>%
  group_by(Subject, Activity) %>%
  summarise_all(mean)
# 結果の出力
write.table(tidy_data, "tidy_data.txt", row.names = FALSE)