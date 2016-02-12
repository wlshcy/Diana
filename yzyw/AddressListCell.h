//
//  AddressCell.h
//  Lynp
//
//  Created by nmg on 16/2/8.
//  Copyright © 2016年 nmg. All rights reserved.
//

#ifndef AddressCell_h
#define AddressCell_h

@interface AddressListCell : UITableViewCell

//- (void)configAddrCell:(NSIndexPath *)indexPath data:(NSMutableArray *)data;

- (void)configAddrCell:(NSDictionary *)data;
@end


#endif /* AddressCell_h */
