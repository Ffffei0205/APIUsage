/**
* 项目名称: ApiUsage
* 文件名称: BaseVM.ets
* 创建时间: 2026-08-11 17:09
* 创建人：  @author Ffffei
* 文件描述: VM（ViewModel，视图模型）：
 * 页面的“大脑”。持有 State，接收 Event，判断要干什么，
 * 然后调用 Model 拿数据、改 State。它不认识 UI，UI 也不直接调它。
*/


import { BaseState } from './BaseState';
import { BaseVMEvent } from './BaseVMEvent';

export abstract class BaseVM<T extends BaseState> {
  protected state: T;

  public constructor(initialState: T) {
    this.state = initialState;
  }

  getState(): T {
    return this.state;
  }

  abstract sendEvent(baseVMEvent: BaseVMEvent);
}

