output "instance_id" {
  value = "${aws_instance.flugel_ec2.id}"
}

output "instance_private_ip" {
  value = "${aws_instance.flugel_ec2.private_ip}"
}

output "bucket_id" {
  value = "${aws_s3_bucket.flugel_s3.id}"
}