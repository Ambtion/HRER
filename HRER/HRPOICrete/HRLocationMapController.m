//
//  HRLocationMapController.m
//  HRER
//
//  Created by quke on 16/7/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRLocationMapController.h"
#import "HRLocationInputView.h"
#import "HRLocationManager.h"
#import "HRUPloadImageView.h"
#import <AddressBookUI/AddressBookUI.h>


#define MAPLocationLEVEL        (0.03f)


@interface HRLocationMapController ()<UITextFieldDelegate,MKMapViewDelegate,HRLocationCategoryViewDelegate>

@property(nonatomic,strong)HRLocationInputView * titleInputView;
@property(nonatomic,strong)HRLocationInputView * addressInputView;

@property(nonatomic,strong)MKMapView * mapView;
@property(nonatomic,strong)UIImageView * pinCenterView;
@property(nonatomic,strong)CLLocation * pinLocation;
@property(nonatomic,assign)BOOL firstLocatoon;
@end

@implementation HRLocationMapController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.myNavController setNavigationBarHidden:YES];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.myNavController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.firstLocatoon = NO;
    [self initUI];
}

- (void)initUI
{
    [self initNavBar];
    [self initHeadView];
    [self initMapView];
    [self initCenterPinView];
}

- (void)initNavBar
{
    UIImageView * barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [barView setUserInteractionEnabled:YES];
    barView.image = [UIImage imageNamed:@"nav_bg"];
    [self.view addSubview:barView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    label.text = @"选择位置";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [barView addSubview:label];
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 66, 26, 66, 33)];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(onRignthButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:rightButton];
    
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 26, 33, 33)];
    [backButton setImage:[UIImage imageNamed:@"list_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onBackButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)initHeadView
{
    self.titleInputView = [[HRLocationInputView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 56.f)];
    self.titleInputView.titleLabel.text = @"位置名称:";
    self.titleInputView.textField.placeholder = @"输入地址位置名称";
    self.titleInputView.textField.delegate = self;
    self.titleInputView.iconView.backgroundColor = RGB_Color(0x49, 0x9a, 0x10);
    [self.view addSubview:self.titleInputView];
    
    
    self.addressInputView = [[HRLocationInputView alloc] initWithFrame:CGRectMake(0, self.titleInputView.bottom, self.view.width, 56.f)];
    self.addressInputView.titleLabel.text = @"地理位置:";
    self.addressInputView.textField.placeholder = @"地图扎点选择";
    self.addressInputView.iconView.backgroundColor = RGB_Color(0xe5, 0x4b, 0x2c);
    [self.addressInputView.textField setUserInteractionEnabled:NO];
    [self.view addSubview:self.addressInputView];
    
    self.categoryView =  [[HRLocationCategoryView alloc] initWithFrame:CGRectMake(0, self.addressInputView.bottom, self.view.width, 56.f)];
    self.categoryView.delegate = self;
    [self.categoryView setSeletedAtIndex:self.categoryIndex];
    [self.view addSubview:self.categoryView];
    
}

- (void)locationCategoryViewDidSeletedIndex:(NSInteger)index
{
    self.categoryIndex = index;
    self.pinCenterView.image = [self  normalImageForType:self.categoryIndex + 1];
}

- (void)initMapView
{
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, self.categoryView.bottom, self.view.width, self.view.height - self.categoryView.bottom)];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    
}

- (void)initMapShow
{
    
    if (self.firstLocatoon) {
        return;
    }
    //设置图区范围
    MKCoordinateSpan span;
    span.latitudeDelta = MAPLocationLEVEL;
    span.longitudeDelta = MAPLocationLEVEL;
    MKCoordinateRegion region;
    self.firstLocatoon = YES;

    if(self.lat == -1 && self.lng == -1){
        self.lat = self.mapView.userLocation.location.coordinate.latitude;
        self.lng = self.mapView.userLocation.location.coordinate.longitude;
        self.pinLocation = self.mapView.userLocation.location;
    }else{
        self.pinLocation = [[CLLocation alloc] initWithLatitude:self.lat longitude:self.lng];
    }
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(self.pinLocation.coordinate.latitude, self.pinLocation.coordinate.longitude);
    region.center = coord;
    region.span = span;
    [self.mapView setRegion:region animated:YES];

}

- (void)initCenterPinView
{
    self.pinCenterView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 38)];
    self.pinCenterView.center = CGPointMake(self.mapView.centerX, self.mapView.centerY - self.pinCenterView.height/2.f);
    self.pinCenterView.image = [self  normalImageForType:self.categoryIndex + 1];
    [self.view addSubview:self.pinCenterView];
}

- (UIImage *)normalImageForType:(NSInteger)type
{
    switch (type) {
        case 1:
            return [UIImage imageNamed:@"map_food"];
            break;
        case 2:
            return [UIImage imageNamed:@"map_look"];
            break;
        case 3:
            return [UIImage imageNamed:@"map_shop"];
        case 4:
            return [UIImage imageNamed:@"map_hotel"];
        default:
            break;
    }
    return [UIImage imageNamed:@"map_food"];;
}



- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self initMapShow];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CLLocationCoordinate2D coor2D = [mapView convertPoint:CGPointMake(self.pinCenterView.centerX, self.pinCenterView.bottom) toCoordinateFromView:self.view];
    
    self.pinLocation = [[CLLocation alloc] initWithLatitude:coor2D.latitude longitude:coor2D.longitude];
    
    WS(ws);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.pinLocation completionHandler:^(NSArray *array, NSError *error) {
        
//       __block  NSString * cityName = @"";
       __block NSString * placeName = @"";
        
        if (array.count > 0) {
            CLPlacemark * placeMark = [array objectAtIndex:0];
//            cityName = placeMark.locality;
            placeName = placeMark.name;
            if (placeName.length) {
                self.addressInputView.textField.text = placeName;
            }
            NSLog(@"FormattedAddressLines,%@",ABCreateStringWithAddressDictionary(placeMark.addressDictionary, NO));;

        }else{
            [NetWorkEntity geoLocationWithLag:ws.pinLocation.coordinate.latitude lng:ws.pinLocation.coordinate.longitude success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray * array = [responseObject objectForKey:@"results"];
                if (array.count) {
                    NSDictionary * dic = [array firstObject];
                    placeName = [dic objectForKey:@"formatted_address"];
                    if (placeName.length) {
                        self.addressInputView.textField.text = placeName;
                    }

                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
        
    

        
     }];

}

- (NSString *)getNameForType:(NSString *)searchType formList:(NSArray *)list
{
    for (NSDictionary * dic in list) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSArray * types = [dic objectForKey:@"types"];
            for (NSString * type in types) {
                if ([type isKindOfClass:[NSString class]] && [type isEqualToString:searchType]) {
                    return [dic objectForKey:@"long_name"];
                }
            }
        }
    }
    return @"";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.titleInputView.textField resignFirstResponder];
}

#pragma mark Action
- (void)onBackButtonDidClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onRignthButtonDidClick:(UIButton *)button
{
    if (self.titleInputView.textField.text.length == 0) {
        [self showTotasViewWithMes:@"请输入位置名称"];
        return;
    }
    if (self.addressInputView.textField.text.length == 0) {
        [self showTotasViewWithMes:@"请在地图选择合适的POI"];
        return;
    }
    
    [self.titleInputView.textField resignFirstResponder];
    [HRUPloadImageView showInView:[self.myNavController view] withPoiTitle:self.titleInputView.textField.text cityId:self.cityId address:self.addressInputView.textField.text loc:[NSString stringWithFormat:@"%f,%f",self.pinLocation.coordinate.longitude,self.pinLocation.coordinate.latitude] categoryType:[self.categoryView seletedIndex] + 1 callBack:^(BOOL isSucesss) {
        
    }];

}

@end
