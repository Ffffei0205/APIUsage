/**
 * 项目名称: ApiUsage
 * 文件名称: MinePageState
 * 创建时间: 2026-08-13 00:29
 * 创建人：  @author Ffffei
 * 文件描述: “我的”页面的数据容器，负责我的页面，子页面不包含
 */


// import { ObservedArray } from 'common';
import { BaseHomeState } from 'commonbusiness';
import { PageEnum } from 'common';

@Observed
export class MinePageState extends BaseHomeState {
  public newContentNumber: number = 0;
  public listItemData: ListGroup[] = [];
  public isLogin: boolean = false;
  public isShowAccountInfo: boolean = false;
  public nickName: string = '';
  public avatarUrl: string = '';
}

@Observed
export class ListGroup {
  public id: number = 0;
  public group: MineItem[] = [];
  // public group: ObservedArray<MineItem> = [];
}

@Observed
export class MineItem {
  public textContent: ResourceStr = '';
  public subTextContent?: ResourceStr = '';
  public symbolSrc?: Resource = $r('sys.symbol.bell');
  public showTotalNum?: boolean = false;
  public type: BuilderEnum = BuilderEnum.CARD_ITEM;
  public builder?: WrappedBuilder<[]>;
  public onclick?: Function = () => {
  };
}

export enum BuilderEnum {
  CARD_ITEM = 'CardItem',
  API_SETTING_ITEM = 'APISettingItem',
  LOGIN_ITEM = 'LoginItem',
  USER_EXPERIENCE_CARD = 'UserExperienceCardItem',
}

@Observed
export class ObservedArray<T> extends Array<T> {
  public constructor(arg?: T[]) {
    if (arg instanceof Array) {
      super(...arg);
    } else {
      super();
    }
  }
}
