//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088511338929304"
//收款支付宝账号
#define SellerID  @"shcaiwu@leepet.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY  @"lf5g3ow3e1bjpo5wbykbsyktziwn0vzn"


//商户私钥，自助生成
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAM6HXLPN5kdnT5rRppsZnWDc67jVRhJBOZafmP0XJ1pSOqqtbJGHkDmN7ydXJGUt+WyHHF016I2FCMKPkJQRgoQDrW7PfPtpXKToiztmohXPL6xtEJecAPCYn6jZYcL/ChjH4+RbFpZm/haBu/W4vRVAmm0vqgjwQxyHLJsI5WzvAgMBAAECgYBPpy09u5+g0luFXm5fS1XDUfEn7DmGONm5GfyrQA7Rav1tbk19I0egqvkdtyI2U7DrBoEOAgia7EAgqbYdJVOsXUkPPXZFSjj8a5rFz7kt3Em2jSlYpew0ExtAoT6D3FUMNgVRaSwxXj9yL+09vy4bDlh94Ph9a9UKkYkDjxPMwQJBAOpWGN7aY6Ar7s8ROW/7bchumougWGIum36BKuWdyW4TjncvnfUbovUhgkXKOsYD/nHq37ENOWjF8iPFhFbyt6cCQQDhnyjS4iuH5rVS5C1eK9igdr2gIgn/4TiMK1ZTYl5VR1EzpB29Jb9HuFsy1a2yOmxyXJ7w1aA1BUOaBKGxgkl5AkBthnYzWrFrwHzqjStiWoqyPne/QN9ubEhC9U4+aeQmrb9Nl5TlZdhhaBsCUYXs3RsE1XldwEeP38zPyVaUaPdLAkEAx3wq4zIX3QQORCj9N+s6kL4L8T7HapdeoQhcPkOWNn5k/GzZ4ngyhJ4q/GpTNmdTpVXhLf0jtl1eJRp9QG56uQJAbMfZ3F5097kfdJfFWjhkZeUq79FTEtCf/+XgRo6WcyaWLMnPzxWORNJzsQO8EwWVPz6X0Jb9kssOzrPVBWcCtA=="


//支付宝公钥
#define AlipayPubKey  @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCAXqNmFBD/0Bs4TWY6sPrun5bKL/Ft0kKZ3bHCflxfyHZAwuUVpGcNy2dsVWZQ55QgGSqgIndbMN14wz9daBDix2zGZd1Jz9p7weJC+onxfwx1sgWc7dd+zyA4kthIO0LNTuI6ohN2rZWStLiLDjrw/qI0JXGXMkA8zJQ7i4LV1QIDAQAB"

#endif
