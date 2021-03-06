from django.contrib.auth.models import User
from django.db import models
from registration.signals import user_registered, user_activated

from mediathread.main.course_details import get_guest_sandbox


class UserSetting(models.Model):
    user = models.ForeignKey(User)
    name = models.CharField(max_length=255)
    value = models.CharField(max_length=255)

    @classmethod
    def get_setting(cls, user, setting_id, default_value):
        try:
            user_setting = UserSetting.objects.get(user=user, name=setting_id)

            if (user_setting.value == 'True' or
                    user_setting.value == 'true'):
                return True
            elif (user_setting.value == 'False' or
                    user_setting.value == 'false'):
                return False
            else:
                return user_setting.value
        except:
            return default_value

    @classmethod
    def set_setting(cls, user, setting_id, value):
        try:
            user_setting = UserSetting.objects.get(user=user, name=setting_id)
            user_setting.value = str(value)
            user_setting.save()
        except:
            UserSetting.objects.create(user=user, name=setting_id, value=value)


class UserProfile(models.Model):
    '''UserProfile adds extra information to a user,
    and associates the user with a group, school,
    and country.'''
    user = models.OneToOneField(User, related_name='profile')
    title = models.CharField(max_length=256, null=True, blank=True)
    institution = models.TextField()
    referred_by = models.TextField()
    user_story = models.TextField(null=True, blank=True)
    self_registered = models.BooleanField(default=False)

    def __unicode__(self):
        return self.user.username


def user_registered_callback(sender, user, request, **kwargs):
    user.first_name = request.POST['first_name'].strip()
    user.last_name = request.POST['last_name'].strip()
    user.save()

    UserProfile.objects.create(user=user,
                               self_registered=True,
                               title=request.POST['title'].strip(),
                               institution=request.POST['institution'].strip(),
                               referred_by=request.POST['referred_by'],
                               user_story=request.POST['user_story'])


def user_activated_callback(sender, user, request, **kwargs):
    # add this user to the guest sandbox by default
    sandbox = get_guest_sandbox()
    sandbox.group.user_set.add(user)


user_registered.connect(user_registered_callback)
user_activated.connect(user_activated_callback)
