import Logger from 'common/src/main/ets/utils/Logger'
import {HttpUtil} from "common";
import DeepSeekApi from '../api/DeepSeekApi';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  private httpUtil:HttpUtil = HttpUtil.getInstance()

  aboutToAppear(): void {

  }

  async queryBalence(){
    // this.httpUtil.fetchRes<BalanceResponse>('https://api.deepseek.com/user/balance').then((a)=>{
    //   this.message =a.data.balance_infos[0].total_balance
    // })
    DeepSeekApi.getBalance('sk-b8eb3fd4087547c98054f11438dbc6f0').then((a)=>{
      this.message = a.balance_infos[0].total_balance
    })


  }

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .onClick(() => {
          this.message = 'Welcome';
        })
      Button('测试网络请求')
        .onClick(() => {
          this.queryBalence()
      })

    }
    .height('100%')
    .width('100%')
  }
}