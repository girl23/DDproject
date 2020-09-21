enum TaskState {
  forGet ,
  forFinish,
  finished,
  forPass,
  passed
}
enum JobCardLanguage{
  cn,
  en,
  mix
}
enum TemporaryDDState{
  closed,
  unClose,
  deleted
}
enum DDState{
  toAudit,//待批准
  unClose,//未关闭
  forTroubleshooting,//待排故
  forInspection,//待检验
  haveTransfer,//已转办
  hasDelay,//已延期
  closed,//已关闭
  deleted,//已删除
  delayClose//延期关闭
}
enum DDOperateButtonState{
  able  ,// 可用
  enable ,//禁用
}
enum comeFromPage{
  fromNewAdd,//DD新增
  fromTaskListAdd,//从任务列表新增DD
  fromTemporaryTransfer,// 临保转办
  fromDDTransfer,//DD转办
  fromDDDelay,//DD延期
}