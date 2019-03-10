# Generated by Django 2.1.5 on 2019-03-10 11:29

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('reports', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Report',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('transcript', models.CharField(max_length=20000)),
                ('date', models.DateTimeField(verbose_name='date published')),
                ('gps_lat', models.DecimalField(decimal_places=6, max_digits=9)),
                ('gps_long', models.DecimalField(decimal_places=6, max_digits=9)),
                ('moving', models.BooleanField()),
            ],
        ),
        migrations.RemoveField(
            model_name='choice',
            name='question',
        ),
        migrations.DeleteModel(
            name='Question',
        ),
        migrations.DeleteModel(
            name='Choice',
        ),
    ]