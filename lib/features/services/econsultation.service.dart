import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class VideoConsultationService {
  final _jitsiMeetPlugin = JitsiMeet();
  final List<String> participants = [];

  Future<void> join(String room, String user) async {
    var options = JitsiMeetConferenceOptions(
      serverURL: "https://meet.jit.si",
      room: room,
      configOverrides: {
        "startWithAudioMuted": true,
        "startWithVideoMuted": true,
      },
      featureFlags: {
        FeatureFlags.welcomePageEnabled: false,
        FeatureFlags.preJoinPageEnabled: true,
        FeatureFlags.chatEnabled: true,
        FeatureFlags.raiseHandEnabled: true,
        FeatureFlags.reactionsEnabled: true,
        FeatureFlags.tileViewEnabled: true,
        FeatureFlags.toolboxEnabled: true,
        FeatureFlags.videoMuteEnabled: true,
        FeatureFlags.audioMuteButtonEnabled: true,
        FeatureFlags.inviteEnabled: true,
        FeatureFlags.notificationEnabled: true,
        FeatureFlags.conferenceTimerEnabled: true,
      },
      userInfo: JitsiMeetUserInfo(
        displayName: user,
        email: "gabi.borlea.1@gmail.com",
        avatar:
            "https://avatars.githubusercontent.com/u/57035818?s=400&u=02572f10fe61bca6fc20426548f3920d53f79693&v=4",
      ),
    );

    var listener = JitsiMeetEventListener(
      conferenceJoined: (url) => debugPrint("✅ Joined: $url"),
      conferenceWillJoin: (url) => debugPrint("➡️ Will Join: $url"),
      conferenceTerminated: (url, error) => debugPrint(" Ended: $url, error: $error"),
      participantJoined: (email, name, role, participantId) {
        if (participantId != null) {
          participants.add(participantId);
        }
        debugPrint("👤 Joined: $name ($email)");
      },
      participantLeft: (participantId) =>
          debugPrint("👤 Left: $participantId"),
      audioMutedChanged: (muted) =>
          debugPrint("🔇 Audio Muted: $muted"),
      videoMutedChanged: (muted) =>
          debugPrint("🎥 Video Muted: $muted"),
      readyToClose: () => debugPrint("✅ Ready to close meeting"),
    );

    await _jitsiMeetPlugin.join(options, listener);
  }
}
