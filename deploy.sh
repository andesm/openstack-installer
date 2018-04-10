#!/bin/bash -x

function my_error() {
    exit 1
}

function wait_ping() {
    sudo ip neigh flush dev ens33
    until ansible $1 -m ping -i hosts
    do
        :
    done       
}

ansible-playbook network.yml -i hosts || my_error
wait_ping openstack 
ansible-playbook disk.yml -i hosts || my_error
ansible-playbook openstack.yml -i hosts || my_error
ansible-playbook test.yml -i hosts || my_error

