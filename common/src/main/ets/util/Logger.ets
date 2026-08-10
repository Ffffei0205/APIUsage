/**
 * 项目名称: ApiUsage
 * 文件名称: Logger
 * 创建时间: 2026-05-26 14:34
 * 创建人：  @author Ffffei
 * 文件描述: 全局日志打印类
 */
import { hilog } from '@kit.PerformanceAnalysisKit';

class Logger {
  private domain: number;
  private prefix: string;
  private format: string = '%{public}s, %{public}s';

  constructor(prefix: string) {
    this.prefix = prefix;
    this.domain = 0xFF00;
  }

  public info(...args: Object[]) {
    hilog.info(this.domain, this.prefix, this.format, args)
  }

  public error(...args: Object[]) {
    hilog.error(this.domain, this.prefix, this.format, args)
  }

  public warn(...args: Object[]) {
    hilog.warn(this.domain, this.prefix, this.format, args)
  }

  public debug(...args: Object[]) {
    hilog.debug(this.domain, this.prefix, this.format, args)
  }

  public log(...args: Object[]) {
    hilog.info(this.domain, this.prefix, this.format, args)
  }
}

export default new Logger('[hanbao]')