#import <Foundation/Foundation.h>
#import <Collaboration/Collaboration.h>

#include <unistd.h>

BOOL auth_userpass(const char *user, const char *pass);

int main(int argc, char *argv[])
{
    char username[100];
    char *password;
    BOOL isValidUser;

    printf("username: ");
    scanf("%s", username);

    password = getpass("password: ");

    isValidUser = auth_userpass(username, password);

    printf("Is valid user: %s\n", isValidUser ? "YES" : "NO");

    return 0;
}

BOOL auth_userpass(const char *user, const char *pass)
{
    NSStringEncoding encoding;
    NSString *user_name;
    NSString *password;
    CBIdentityAuthority *identity_authority;
    CBIdentity *identity;
    CBUserIdentity *user_identity;

    encoding = [NSString defaultCStringEncoding];
    user_name = [NSString stringWithCString:user encoding:encoding];
    password = [NSString stringWithCString:pass encoding:encoding];

    /*
     * If the identity should be grabed for network (like LDAP)
     */
    identity_authority = [CBIdentityAuthority localIdentityAuthority];
    identity = [CBIdentity identityWithName:user_name
                           authority:identity_authority];
    if (identity == nil || ![identity isKindOfClass:[CBUserIdentity class]])
    {
        return 0;
    }

    user_identity = (CBUserIdentity *) identity;
    return user_identity.isEnabled &&
        [user_identity authenticateWithPassword:password];
}
