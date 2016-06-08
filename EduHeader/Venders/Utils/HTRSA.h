#import <Foundation/Foundation.h>

@interface HTRSA : NSObject {
    SecKeyRef publicKey;
    SecCertificateRef certificate;
    SecPolicyRef policy;
    SecTrustRef trust;
    size_t maxPlainLen;
}
- (HTRSA *)initWithData:(NSData *)keyData;
- (HTRSA *)initWithPublicKey:(NSString *)publicKeyPath;

- (NSData *) encryptWithData:(NSData *)content;
- (NSData *) encryptWithString:(NSString *)content;
- (NSString *) encryptToString:(NSString *)content;

@end
