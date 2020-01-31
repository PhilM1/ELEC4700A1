%Assignment 1 for ELEC 4700 - Philippe Masson

timestep = 1e-14; %10fs
region_size_x = 200e-9; %meter
region_size_y = 100e-9; %meter
numParticles = 10000;
simLength = 1000; %number of iterations of the simulation
temperature = 300; %Kelvin
mass_electron = 9.10938356e-31; %electron rest mass [kg]
mass_effective = 0.26*mass_electron; %electron effective mass [kg]
const_boltzman = 1.38064852e-23; %Boltzman constant [m^2 kg / s^2 K]
velocity_thermal = sqrt(const_boltzman*temperature/mass_effective); %thermal velocity

particleArray = [];
%particle array is in following format: 
%xPos, yPos, Velocity Mag, xDir(norm), yDir(norm)

Part2 = 1;
Part3 = 0;

%initialize the particles
for i = 1:numParticles
    %init positions
    particleArray(i,1) = rand * region_size_x;
    particleArray(i,2) = rand * region_size_y;
    
    if(Part2 == 1 || Part3 == 1)
        vth = randn*1e5 + velocity_thermal;
        %vth = sqrt(random('chisquare',3));%*velocity_thermal;
    else
       vth = velocity_thermal;
    end
    %init velocity
    particleArray(i,3) = vth; %velocity magnitude
    particleArray(i,4) = (rand * 2) - 1; %x-direction (normalized)
    particleArray(i,5) = sqrt(1-particleArray(i,4)^2); %y-direction (normalized)
    if(rand > 0.5)
        particleArray(i,5) = particleArray(i,5) * -1;
    end
        
end

%plot histogram of velocities
figure(1);
histogram(particleArray(:,3));
title(['Histogram of Velocity Distribution, Mean = ' num2str(mean(particleArray(:,3)))]);
xlabel('Thermal Velocity of a Given Particle');
ylabel('Counts');

for simCount = 1:simLength
    currTime = simCount * timestep;
        
    
    %update particle positions
    new_xPos = particleArray(:,1) + timestep * particleArray(:,3) .* particleArray(:,4);
    new_yPos = particleArray(:,2) + timestep * particleArray(:,3) .* particleArray(:,5);
    
    %check boundary conditions
    for i = 1:numParticles
        if(new_xPos(i) < 0) %bounce off boundary
            new_xPos(i) = abs(new_xPos(i) - particleArray(i,1));
            particleArray(i,4) = particleArray(i,4) * -1; %swap direction
        elseif(new_xPos(i) > region_size_x) %bounce off boundary
            new_xPos(i) = region_size_x - abs(new_xPos(i) - particleArray(i,1));
            particleArray(i,4) = particleArray(i,4) * -1; %swap direction
        end
        
        if(new_yPos(i) < 0) %bounce off boundary
            new_yPos(i) = abs(new_yPos(i) - particleArray(i,2));
            particleArray(i,5) = particleArray(i,5) * -1; %swap direction
        elseif(new_yPos(i) > region_size_y) %bounce off boundary
            new_yPos(i) = region_size_y - abs(new_yPos(i) - particleArray(i,2));
            particleArray(i,5) = particleArray(i,5) * -1; %swap direction
        end
    end
    
%     figure(1);
%     hold on;
%     plot([particleArray(1,1), new_xPos(1)],[particleArray(1,2), new_yPos(1)]);
%     plot([particleArray(2,1), new_xPos(2)],[particleArray(2,2), new_yPos(2)]);
%     plot([particleArray(3,1), new_xPos(3)],[particleArray(3,2), new_yPos(3)]);
%     plot([particleArray(4,1), new_xPos(4)],[particleArray(4,2), new_yPos(4)]);
%     plot([particleArray(5,1), new_xPos(5)],[particleArray(5,2), new_yPos(5)]);
%     plot([particleArray(6,1), new_xPos(6)],[particleArray(6,2), new_yPos(6)]);
%     plot([particleArray(7,1), new_xPos(7)],[particleArray(7,2), new_yPos(7)]);
%     xlim([0,region_size_x]);
%     ylim([0,region_size_y]);
%     title(['Simulation Count: ', num2str(simCount), ', Timestep: ', num2str(timestep)]);
%     hold off;
    
    particleArray(:,1) = new_xPos;
    particleArray(:,2) = new_yPos;
    
    
    figure(2);
    scatter(particleArray(:,1), particleArray(:,2), 5);
    axis([0, region_size_x, 0, region_size_y]);
    pause(0.01);
    disp(['simcount: ', num2str(simCount), ' of ', num2str(simLength)]);
end