# WeatherForecast

###代码片段
    //选中那一行
     - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
       //获取模型对象
       XPCityGroup *cityGroup = self.cityGroupArray[indexPath.section];
        //发送通知，包含参数(选择的城市名字)
       [[NSNotificationCenter defaultCenter] postNotificationName:@"DidCityChange" object:self userInfo:@{@"CityName":cityGroup.cities[indexPath.row]}];
        //收回控制器
       [self dismissViewControllerAnimated:YES completion:nil];
    }
  
