# WeatherForecast
##代码片段
- (void)listenChangeCity:(NSNotification *)notification {<br>
    //获取传过来的参数<br>
    NSString *cityName = notification.userInfo[@"CityName"];<br>
    //汉字：上海->shanghai<br>
    //笔记中的方式二<br>
    NSLog(@"城市名字:%@",cityName);<br>
    
    //地理编码获取城市拼音<br>
    [self.geocoder geocodeAddressString:cityName completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {<br>
        CLPlacemark *placemark = [placemarks lastObject];<br>
        //将服务器返回地标中location值赋值self.userLocation(!!!!!)<br>
        self.userLocation = placemark.location;<br>
        NSString *cityStr = placemark.addressDictionary[@"City"];<br>
        //更新城市label<br>
        self.headerView.cityLabel.text = cityStr;<br>
        
        NSLog(@"城市拼音:%@;000--%f", cityStr, self.userLocation.coordinate.latitude);<br>
    }];<br>
    
    //发送请求<br>
    [self sendRequestToServer];<br>
}<br>
