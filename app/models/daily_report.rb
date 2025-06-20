class DailyReport < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  # 公開／非公開の設定
  enum visibility: { public_report: 0, private_report: 1 }

  # 管理者は全件、本人は全件、それ以外は公開のみ取得する
  scope :accessible_for, ->(viewer, owner_id) {
    # viewer が Admin モデルかどうか
    is_admin = viewer.is_a?(Admin)
    # viewer が User モデルで owner_id と同じかどうか
    is_owner = viewer.respond_to?(:id) && viewer.id == owner_id

    if is_admin || is_owner
      where(user_id: owner_id)
    else
      where(user_id: owner_id, visibility: :public_report)
    end
  }



  # バリデーション
  validates :date,     presence: true
  validates :location, presence: true
  validates :content,  presence: true

  # タスク達成度と自己評価について（1〜10の数値）
  validates :task_achievement, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }, allow_nil: true
  validates :self_evaluation,  numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }, allow_nil: true

  # 将来成長予測用の属性（DBにカラムがある前提）
  validates :future_goal_value, numericality: { allow_nil: true, greater_than: 0, less_than_or_equal_to: 100 }
  validates :future_goal_days, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  # 前回の日報を取得するメソッド
  def previous_report
    self.class.where(user_id: user_id).where('date < ?', date).order(date: :desc).first
  end

  # パフォーマンススコア：タスク達成度と自己評価の平均値（1〜10の数値）
  def performance_score
    if task_achievement.present? && self_evaluation.present?
      ((task_achievement + self_evaluation) / 2.0).round(1)
    else
      nil
    end
  end
end