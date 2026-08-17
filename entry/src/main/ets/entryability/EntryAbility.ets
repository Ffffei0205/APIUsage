import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { BaseAbilityHelper } from 'abilitycommon';


export default class EntryAbility extends UIAbility {
  private baseAbilityHelper: BaseAbilityHelper = new BaseAbilityHelper();

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.baseAbilityHelper.doOnCreate(this.context, want, launchParam);
  }

  onDestroy(): void {
    this.baseAbilityHelper.doOnDestroy();
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    this.baseAbilityHelper.doOnWindowStageCreate(windowStage);
  }

  onWindowStageDestroy(): void {
    this.baseAbilityHelper.doOnWindowStageDestroy();
  }

  onForeground(): void {
    this.baseAbilityHelper.doOnForeground();
  }

  onBackground(): void {
    this.baseAbilityHelper.doOnBackground();
  }
}
