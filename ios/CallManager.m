/*
 * Copyright (c) 2011-2018, Zingaya, Inc. All rights reserved.
 */

#import "CallManager.h"

@interface CallManager()
@property(nonatomic, strong) VIClient *client;
@property(nonatomic, strong) NSMutableDictionary<NSString *, VICall *> *calls;
@property(nonatomic, strong) NSMutableDictionary<NSString *, VIEndpoint *> *endpoints;
@property(nonatomic, strong) NSMutableDictionary<NSString *, VIVideoStream *> *videoStreams;
@property(nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *callEndpoints;
@end

@implementation CallManager

+ (CallManager *)getInstance {
    static dispatch_once_t onceToken;
    static CallManager *callManager;
    dispatch_once(&onceToken, ^{
        callManager = [CallManager new];
    });
    return callManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _calls = [NSMutableDictionary dictionary];
        _endpoints = [NSMutableDictionary dictionary];
        _callEndpoints = [NSMutableDictionary dictionary];
        _videoStreams = [NSMutableDictionary dictionary];
        _client = [[VIClient alloc] initWithDelegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

+ (VIClient *)getClient {
    return [CallManager getInstance].client;
}

+ (void)addCall:(VICall *)call {
    [[CallManager getInstance].calls setObject:call forKey:call.callId];
}

+ (VICall *)getCallById:(NSString *)callId {
    if (callId) {
        return [[CallManager getInstance].calls objectForKey:callId];
    }
    return nil;
}

+ (VICall *)getCallByEndpointId:(NSString *)endpointId {
    return [[CallManager getInstance].calls objectForKey:[[CallManager getInstance].callEndpoints objectForKey:endpointId]];
}
+ (NSString *)getCallIdByEndppointId:(NSString *)endpointId {
    if (endpointId) {
        return [[CallManager getInstance].callEndpoints objectForKey:endpointId];
    }
    return nil;
}

+ (void)removeCallById:(NSString *)callId {
    [[CallManager getInstance].calls removeObjectForKey:callId];
}

+ (void)addEndpoint:(VIEndpoint *)endpoint forCall:(NSString *)callId {
    [[CallManager getInstance].endpoints setObject:endpoint forKey:endpoint.endpointId];
    [[CallManager getInstance].callEndpoints setObject:callId forKey:endpoint.endpointId];
}

+ (VIEndpoint *)getEndpointById:(NSString *)endpointId {
    if (endpointId) {
        return [[CallManager getInstance].endpoints valueForKey:endpointId];
    }
    return nil;
}

+ (void)removeEndpointById:(NSString *)endpointId {
    [[CallManager getInstance].endpoints removeObjectForKey:endpointId];
    [[CallManager getInstance].callEndpoints removeObjectForKey:endpointId];
}

+ (void)addVideoStream:(VIVideoStream *)videoStream {
    [[CallManager getInstance].videoStreams setObject:videoStream forKey:videoStream.streamId];
}

+ (VIVideoStream *)getVideoStreamById:(NSString *)videoStreamId {
    if (videoStreamId) {
        return [[CallManager getInstance].videoStreams objectForKey:videoStreamId];
    }
    return nil;
}

+ (void)removeVideoStreamById:(NSString *)videoStreamId {
    [[CallManager getInstance].videoStreams removeObjectForKey:videoStreamId];
}


@end
