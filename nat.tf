#NAT GW
resource "aws_eip" "nat1" {
    vpc = true
}
resource "aws_eip" "nat2" {
    vpc = true
}
resource "aws_nat_gateway" "nat-gw-1" {
    allocation_id = "${aws_eip.nat1.id}"
    subnet_id = "${aws_subnet.main-public-1.id}"
    depends_on = ["aws_internet_gateway.main-gw"]
}
resource "aws_nat_gateway" "nat-gw-2" {
    allocation_id = "${aws_eip.nat2.id}"
    subnet_id = "${aws_subnet.main-public-2.id}"
    depends_on = ["aws_internet_gateway.main-gw"]
}
#Private route table
resource "aws_route_table" "main-private-1" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat-gw-1.id}"
    }
    tags = {
        Name = "main-private-1"
    }
}
resource "aws_route_table" "main-private-2" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat-gw-2.id}"
    }
    tags = {
        Name = "main-private-2"
    }
}
#Private subnets route association
resource "aws_route_table_association" "main-private-1-a" {
    subnet_id = "${aws_subnet.main-private-1.id}"
    route_table_id = "${aws_route_table.main-private-1.id}"
}
resource "aws_route_table_association" "main-private-2-a" {
    subnet_id = "${aws_subnet.main-private-2.id}"
    route_table_id = "${aws_route_table.main-private-2.id}"
}