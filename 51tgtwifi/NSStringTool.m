//
//  NSStringTool.m
//  51tgtwifi
//
//  Created by 51tgt on 2017/11/8.
//  Copyright © 2017年 weiyuxiang. All rights reserved.
//

#import "NSStringTool.h"

@implementation NSStringTool


+(NSString *)convertToNSStringWithNSData:(NSData *)data
{
    
    
    NSMutableString *strTemp = [NSMutableString stringWithCapacity:[data length]*2];
    
    
    const unsigned char *szBuffer = [data bytes];
    
    
    for (NSInteger i=0; i < [data length]; ++i) {
        
        [strTemp appendFormat:@"%02lx",(unsigned long)szBuffer[i]];
        
    }
    
    
    return strTemp;
    
}


//1 获得字符串的长度：
-(int)convertToInt:(NSString*)strtemp {
    
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
    
}

//2 10进制转16进制：
-(NSString *)ToHex:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;
        }
        
    }
    return str;
}

//3 16进制转换成十进制：
- (NSString *)to10:(NSString *)num
{
    NSString *result = [NSString stringWithFormat:@"%ld", strtoul([num UTF8String],0,16)];
    return result;
}

//4 将16进制的字符串转换成NSData：
- (NSData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    NSLog(@"hexdata: %@", hexData);
    return hexData;
}


//5 字符串转换16进制：
-(NSString *)hexStringFromString:(NSString *)string{
    NSData *myD=[string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes=(Byte *)[myD bytes];
    //byte－16
    NSString *hexStr=nil;
    for (int i=0; i<[myD length];i++) {
        NSString *newHexStr=[NSString stringWithFormat:@"%x",bytes[i]&0xff];
        if ([newHexStr length]==1) {
            hexStr=[NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        }else{
            hexStr=[NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
    }
    return hexStr;
}

//6 16进制字符串转byte格式
-(NSData*) hexToBytes:(NSString *)str{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= str.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [str substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}


//8 字符串补零操作
-(NSString *)addZero:(NSString *)str withLength:(int)length{
    NSString *string=nil;
    if (str.length<length) {
        for (int i=0;i<length-str.length; i++) {
            string=[NSString stringWithFormat:@"0%@",str];
            str=string;
        }
    }
    return string;
    
}


@end
