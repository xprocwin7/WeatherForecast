## WeatherForecast

###温馨提示：如果报错，修改下pch的文件路径即可。

###代码片段
        - (void)listenChangeCity:(NSNotification *)notification {
                //获取传过来的参数
                NSString *cityName = notification.userInfo[@"CityName"];
                //汉字：上海->shanghai
                 //笔记中的方式二
                 NSLog(@"城市名字:%@",cityName);
                //地理编码获取城市拼音
                [self.geocoder geocodeAddressString:cityName completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks,   NSError * _Nullable error) {
                CLPlacemark *placemark = [placemarks lastObject];
                //将服务器返回地标中location值赋值self.userLocation(!!!!!)
                self.userLocation = placemark.location;
                NSString *cityStr = placemark.addressDictionary[@"City"];
                //更新城市label
                self.headerView.cityLabel.text = cityStr;
                 NSLog(@"城市拼音:%@;000--%f", cityStr, self.userLocation.coordinate.latitude);
                }];
                //发送请求
                [self sendRequestToServer];
        }
